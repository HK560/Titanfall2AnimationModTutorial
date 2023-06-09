# 泰坦陨落2修改武器动画教程

本教程还未完成，之后会使用chatgpt翻译成英语。
作者：HK560

## 需要的文件
1. 你想要进行移植的武器模型和动画
2. 你想要进行移植的武器模型的原本游戏的第一人称手臂模型
3. 你想要替换的泰坦陨落2的武器模型和动画
4. 泰坦陨落2的第一人称手臂模型

## 需要的软件
1. Blender v2.3+
2. Blender插件 `Bone Animation Copy Tool`（可以在github上搜索该插件）
3. Blender插件 `Blender Source Tools`
4. mdlshit v2.3.2
5. Tianfall VPK Tool
6. Crowbar 0.74+



## 制作第一人称武器动画

### 1.导入模型和动画

首先导入你想要替换的武器模型的第一人称模型文件，

如图，这里使用`ptpov_wingman_elite_v_wingman_elite.smd`

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604121109.png)

然后继续导入泰坦陨落2的第一人称手臂模型动画进入blender，这里使用的是`pov_pilot_light_jester_f.smd`

记得设置`append to target`

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604121233.png)

结果如图

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604121329.png)


然后在姿态模式下确认模型是否都跟着骨骼走。

另外记得保存blender工程文件




同样地，针对我们要准备进行移植的武器模型，也单独创建一个新的工程文件，按照上面类似的步骤，导入武器模型和手臂模型

变成如图的样子

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604145340.png)

此刻我们有两个blender的工程文件，一个是泰坦陨落2原来的，另一个是即将制作为武器mod的。

此时你可以为他们分别导入对应的动画文件测试是否正常：
![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604145749.png)

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604145817.png)

简单测试一下，都没问题的话，我们将姿态恢复清空到默认状态。

清空姿态：
姿态模式下按下`A` 全选骨骼，之后点击如图按钮，这样你就会回到原来默认的姿态
![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604145932.png)


### 2.对动画文件进行分类
在我们对泰坦陨落2的武器的mdl文件进行反编译后，我们会得到一系列模型smd文件，还有动画的smd文件，还有一个qc文件

打开qc文件，找到如图的行

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604150217.png)

这些`$animation` 是对动画文件进行声明，告诉编译器动画文件的路径和名字，还有一些fps的设置，详细文档请查看valve的文档

在`$animation` 之后是如图的一堆 `$sequence`

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604150614.png)

这些十分重要，这告诉游戏如何使用这些动画，详细讲解起来很复杂，更多信息请查看valve的文档

为了能使我们后面重新制作的动画能正常生效，我们需要找到并区分出那些delta动画和非delta动画

如何确定哪些是delta动画？

如图这个 `$sequence`中，含有一个`delta`的参数，则这个`$sequence`使用到的两个动画"attack_slide_anim" "attack_ads_anim" 都是delta动画，反之如果没有delta这个参数则代表不是delta动画

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604151012.png)

通过名字attack_slide_anim我们可以找到这个动画文件的路径

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604151218.png)

通过这样分析查看每个`$sequence`，区分出每个动画文件是delta还是非delta。我知道这听起来十分麻烦，但这是必须步骤，需要对一百多个动画文件分类，这样后面制作动画时候才能不会破坏动画。

为了方便称呼，后文会将delta动画称之为`delta动画`，非delta动画称之为`nodelta动画`。

#### 快速分类动画
接下来介绍一个能够快速分类这些delta和nodelta动画的方法。

在我们使用crowbar对mdl进行反编译时，请按照下图的设置，尤其是和红框内的设置一样

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230609145558.png)

然后我们进行反编译，这样反编译得到的动画文件每行会带有如下图的注释说明

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230609145858.png)

然后使用我的bat脚本，你可以从仓库下载，或者自己新建一个bat编辑复制我的代码进去。把这个bat脚本放到同动画文件目录下运行。

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230609150410.png)

脚本运行完成后会提示复制了多少个delta文件和nodelta文件，此时你会发现该目录下会多出两个文件夹，里面分别是delta动画和nodelta动画。这样你就分类好了动画文件。

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604153722.png)

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604153746.png)

区分出来之后我们后面重点处理的是非delta动画，我们要将新制作的武器动画做到这些非delta动画里面去

但首先，我们还是回到模型和骨骼的处理上。

### 合并模型和骨骼

我们新建一个blender工程文件，把上面两个工程文件的模型和骨骼都复制进去，如图

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604154546.png)

此时我们这个工程文件里面有两套骨架还有对应的模型文件，我习惯将他们这样分类

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604154915.png)

记得给网格模型添加上他们对应骨架的修改器

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604155516.png)


我们先改变一下骨骼的显示，

姿态模式下选择一个骨骼，如图改变形状显示，点击X删掉

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604164920.png)

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604165039.png)

此时再按下`A` 全选骨骼，再按下`Ctrl + C` 选择`Copy bone shape`

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604165202.png)

这样就删掉那些小球球了

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604165247.png)


另外为了方便确定视角，我们可以加个摄像机，绑定到摄像机骨骼上

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604170111.png)

将摄像机移动到 jx_c_camera 骨骼位置，调整方向无误后添加父级关系即可

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604170144.png)


现在大概是这个样子

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604170950.png)

接下来我们要把武器模型的骨骼拆出来并合并到泰坦陨落2的武器骨架中，我强烈建议现在复制备份当前的工程文件，之后如果遇到什么问题可以从这里开始。


复制(`Shift + D`)一份移植武器的骨架,也可以把武器模型也复制一份

找到你移植的武器动画所需要的所有骨骼，然后删掉其他不需要的骨骼，例如移植武器骨架的身体骨骼之类的

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604171526.png)

变成如此

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604171725.png)

然后我们调整这个骨架和额外复制出来的武器模型位置，与原本武器模型位置差不多重合，应用变换

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604172830.png)

然后我们将这个只有移植武器所需骨骼的骨架与泰坦陨落2游戏原本的武器骨架合并

选中这两个骨架，`Ctrl + J`合并

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604171939.png)

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604173106.png)

然后找你的移植武器的根骨骼设置它的父级为`weapon_bone`,如图

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604174139.png)

然后姿态模式下拖拽一下骨骼，看模型是否跟着移动

保存工程文件

--------------------------------

### 移植动画

接下来我示范一下如何得到基于我们想要骨架的移植动画文件。

还记得我们上面分类出来的nodelta 和delta动画吗，我们先需要处理那些nodelta动画。

为什么需要分类呢？nodelta动画和delta动画有什么区别？

nodelta的动画都是完整的动画，有了骨架之后导入这些动画，你就能直接得到想要的动画效果。

但是delta的动画是不完整的，这些delta动画是用来叠加的，他们是需要一个基础动画，再叠加这些delta动画才能得到比较直观的动画。

你可以导入看看那些nodelta的动画文件，这些动画都是完整的，不需要再混合或叠加，比如换弹，切枪，瞄准都是nodelta动画。

我们就需要先给这些nodelta动画做移植。

但为了移植动画，我们需要先学学如何映射骨骼。


接下来的操作会比较复杂

我们先给移植武器的原本骨架导入动画。这里是reload动画举例，注意这个骨架是原本移植武器完整的骨架，导入之后如图

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604180212.png)

现在我们的目标就是，将我们上面合并好的骨架的动画和移植武器骨架动画一样，为此我们需要Bone animation copy 这个插件

这个插件的作用主要是将骨架之间的骨骼动画进行映射。

为了方便接下来的映射，我们先给两个骨架分别导入对应的动画。合并好的骨架导入泰坦陨落2原本的换弹动画，而原本移植武器的骨架导入你准备进行移植的动画。

打开这个插件。第一个框选择我们上面合并了的骨架，第二个框选择原本移植武器的骨架

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604180620.png)


我们要做的就是找到对应的骨骼并设置映射，点击右边的“+”添加一个映射关系
然后就会多出一个框，左边设置对应要被映射的骨骼名字，右边设置映射的骨骼名字。右边骨骼映射到左边骨骼

一般来说我们要映射根骨骼，手臂骨骼还有武器骨骼。

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604181848.png)

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230607191732.png)

1. 红框部分是几个基础功能，从左到右分别是映射列表，旋转设置，位移设置，IK设置

- 映射列表：你所有添加了映射的骨骼都会显示在这里，可以通过勾选进行批量管理，比如批量删除添加等。
- 旋转设置：设置骨骼是否同步被映射骨骼的旋转，应用旋转之后还能对旋转角度进行修正
- 位移设置：设置骨骼是否同步被映射骨骼的位移坐标，可以单独给X，Y，Z轴单独设置是否同步
- IK 设置： 给骨骼设置IK，我没用过不太清楚

2. 黄框部分就是你添加了的映射骨骼和被映射骨骼，每一项的左边是需要被映射的骨骼，右边是映射骨骼，通俗理解就是右边骨骼的的动画会同步到左边的骨骼。

3. 蓝框部分可以添加或者删除映射关系 

4. 绿框部分是功能项，上到下分别是子级映射，名称映射，镜像映射；试用一下就知道什么功能了
- 子级映射，自动映射被选中的映射关系的子级骨骼
- 名称映射，自动映射被选中的映射关系中名称相近的骨骼
- 镜像映射，自动映射被选中的映射关系的对称骨骼

5. 橙色框给当前设置的映射关系组保存或切换

6. 切换映射约束预览

在旋转设置这里可以调整角度，点亮左边按钮表示启用旋转同步和设置

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604182056.png)

在这里调整是否映射坐标，点亮左边按钮表示启用

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230604182154.png)

自行调整角度，与移植武器的手臂模型进行比较

一般来说我首先会选择映射根骨骼并调整，确保大体方向一致，然后映射手腕手指的关节，武器的骨骼

如果你还想要移植镜头抖动之类的，当然也可以映射到镜头的骨骼`jx_c_camera`，不过需要确保方向没错。

另外记得，人物要朝向-y轴，否则在游戏里面动画会朝向错误的方向。


----------------------------------

设置好映射后，我们可以

首先选择带有需要移植动画的骨架，导入需要映射的动画并选中，如图

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230605191057.png)

这时候就可以尝试播放动画，看`合并骨架（就是上面泰坦陨落骨架与武器骨骼合并了的骨架，为了方便以后都称之为合并骨架）`的骨骼是否也一起动了起来。如果没有就要确定一下是不是没生效或者映射错了

没问题的话我们选择合并骨架，然后可以新建个动画序列，我这里就复制了个动画序列`reload_seqN`，此时按空格播放继续序列里面没有动画帧骨骼也会动起来，因为我们之前已经映射了。



我一般是这样操作的，比如我现在要移植换弹动画，在泰坦陨落中武器解包出来的换弹动画文件一般叫`reload_seq.smd`或者类似的,我们就先给合并骨架导入这个泰坦陨落原来的换弹动画。因为我们的合并骨架中是有泰坦陨落原本的骨骼的，所以这动画文件是可以驱动这个骨架里的骨骼的，不过那些新合并进来的移植武器的骨骼当然是不会动了。

然后我们给`原移植骨架(就是原本需要移植武器的骨架，为了方便以后都称之为原移植骨架)`导入需要移植的动画，这个动画当然能驱动这个骨架的骨骼。

而在上面我们映射了骨骼，那么此时我们原移植骨架上的动画会同步到合并骨架上，因此如果你现在播放原移植骨架的动画，合并骨架的骨骼也会跟着动。

此时我们在物体模式下，切换到合并骨架，为了制作移植动画并导出，我们先新建个动画序列命名为`reload_seqN`，然后按空格播放，确定合并骨架的骨骼映射生效了，播放的是原移植骨架的动画。

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230605191512.png)

然后我们为这个动画序列的开头和最后添加个关键帧，并设置结束点，这个结束点就代表你这个动画长度了，一般就和被移植的动画长度一致就行。不过多多少会和原本的动画长度不同，所以帧变多的话动画就会加速播放了。你当然还可以在这个动画序列里面编辑为其他骨骼编译动画，不过已经被映射的骨骼就不会被影响了。

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230607200935.png)

此时，合并骨架使用的是我们新建的动画序列，我们准备用来保存移植动画，原移植骨架使用的是被移植的动画。我们在物体模式下，选择合并骨架，按空格播放动画，动画能够符合我们的预期后，我们就可以准备保存导出。

如图，进行点选。

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230605191912.png)

这样我们就会得到我们想要合并骨架且带有我们想要移植动画的动画文件了。然后你对其他需要移植的nodelta动画都这样改就行了。

移植动画大概就是这样，但是我们制作武器mod的过程肯定不会那么直接。正常来说我们要先调整模型处理模型还有骨骼，制作动画是最后一步，但因为本教程重点是移植武器动画所以这些步骤都忽略了。

如果你只修改这些nodelta动画进行编译，进入游戏后你可能会发现模型位置不对，动画异常，这是因为你还没有将delta动画进行处理，下面讲解如何处理delta动画，这是十分重要的一步。


--------------------------------
### 处理delta动画（十分重要）

在详细的步骤之前，我们需要明白为什么要处理delta动画，和处理的原理。

上面说过delta动画是不能直接用的，当你只导入delta动画时是无法得到想要的结果的。delta动画是用于已存在了基础的动画上再进行叠加，其动画文件保存的是每个骨骼的相对于自身的位移，而非普通动画中的父子级的位移。

我们解包出的泰坦陨落2的delta动画文件中，只有原本的骨骼在里面，而我们现在的合并骨架里面不仅有原本的骨骼，还有新加的移植武器的骨骼。

当我们在游戏里使用合并骨架再使用这些没有修改过的delta动画，那些移植武器的骨骼会因为delta动画里面的没有定义而乱飞，导致动画和模型错误。

这根本的原因就是因为delta动画里缺少合并骨架里新加入的骨骼，要解决这个问题我们需要修改所有delta动画文件，让他们在不修改原本动画的情况下加入新的骨骼。

我们的大致操作就是在blender中修改导入delta动画并修改再导出得到带合并骨架中新骨骼的delta动画。

不过我们需要先对合并骨架进行处理，接下来是详细步骤。

新建blender项目，把我们之前的合并骨架复制一份进去，为了方便查看骨骼我们可以把模型也顺便复制进去。

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230606191924.png)

为了之后方便查看骨骼的方向，我们设置骨架的骨骼显示轴向，如图


![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230606192341.png)


我们的目标是将所有的骨骼的+y轴朝向都朝向blender的世界坐标的+x轴。

切换到姿态模式，我们查看一下根骨骼，一般名字就叫`jx_c_delta`，此时它骨骼+y轴朝向应该和blender的世界坐标的+y轴一样。如图

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230607220712.png)

我们需要将其按照z轴旋转，使其骨骼+y轴朝向blender的世界坐标的+x轴，如图

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230607222116.png)

现在我们的目标是将所有的骨骼都和所选的根骨骼的位置朝向一致。

我们先让所有骨骼的位置坐标和根骨骼一致。在确保已经选中了该根骨骼的情况下，按下`A`全选所有骨骼，再按下`Ctrl + C`，选择`Copy Visual Location`, 如图

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230607223621.png)

然后大概会像这样变很奇怪的，只有一些骨骼的位置和根骨骼一样了，因为它这个复制位置是按骨骼层级的，需要重复上述步骤复制多几次。

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230607224644.png)

最后确保所有骨骼都和根骨骼的位置一样，大概会是这样

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230607224818.png)

我们还需要所有骨骼的朝向和根骨骼一致。同样的,确保已经选中了根骨骼的情况下，按下`A`全选所有骨骼，再按下`Ctrl + C`，选择`Copy Visual Rotation`，如图，同样的你要多重复几次步骤，确保所有骨骼的朝向都和根骨骼一样。

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230607225552.png)

当所有骨骼的位置和朝向都一致没问题后我们`Ctrl + A`应用为静置姿态。

接下来导入所有的delta动画，然后依次选择每个动画并直接导出，这样我们就能得到含有新骨骨骼的所有delta动画了（步骤同上面导出nodelta动画一样）。

用这些新的delta动画替换原本的delta动画进行编译即可。


---------------------------------------------------
### 使用$bonemerge

在qc文件中使用$bonemerge声明你的模型每个骨骼，可以防止studiomdl把你的骨骼给折叠优化了。不然可能会导致动画错误或者异常。

在我们导出了带有合并骨架的武器模型文件后，可以通过记事本打开，如图

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230608200313.png)

类似于红框里面的这些行是我们模型的骨骼，把他们都复制一下

在notepad++中新建个文件，将上面复制内容粘贴进去，如图

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230608200613.png)

按`Ctrl + H`,然后按如图设置,开启正则表达式,全部替换

- 搜索：`^\s*\d+\s*"(.+)"\s*-?\d+\s*$`
- 替换为：`$bonemerge "\1"`

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230608210520.png)

然后就得到如图的内容，保存为bonemerge.qci文件即可

![](https://cdn.jsdelivr.net/gh/HK560/MyPicHub@master/res/pic/20230608211135.png)

我们要用就把这个qci文件放到qc文件同目录下，然后在qc文件里面写:`$include "bonemerge.qci"` 即可。


--------------------------------
### 制作delta动画

其实我们会发现，有不少delta动画都十分重要，我们往往也需要修改他们，比如开火动画`attack_anim.smd``attack_ads_anim.smd`之类的。

我们要如何制作修改这些delta动画呢？

首先我们需要明确要修改delta动画的作用，知道他是如何叠加生效的。接下来用制作`attack_anim`动画举例，这个动画是武器在站立非瞄准状态下开火的动画，它是基于idle的动画基础上再播放这个`attack_anim`动画实现完整的开火动画。意思就是：

正常握持武器的idle动画 + 开火delta动画 = 完整的开火动画

而我们目前拥有完整独立的开火和动画，和完整独立的idle动画，将他们“相减”就能得到`attack_anim`动画，即 ：

开火delta动画 = 完整的开火动画 - 正常握持武器的idle动画

如何“相减”得到呢？我们要借助Crowbar工具来。

通过编写特殊的qc文件，使用crowbar来编译，再反编译来得到delta动画，以下是qc文件内容：

```
$maxverts  200000                           //确保你的模型面数小于这个，不够就调大
$modelname "test/your_model_file.mdl"        //生成mdl的文件名和存储路径，可以自定义
$model "test" "your_model_file.smd"          //指向你带有和动画一样的骨架的模型文件
$include "bonemerge.qci"                    //指向定义了$bonemerge的qci文件

//将ads_out_animN.smd文件的动画定义为""ads_out_animN",播放速度为30FPS，此文件为被减去的动画
$animation "ads_out_animN" "getdelta/ads_out_animN.smd"{        
    fps 30
}

//将"ads_out_animN"的第十帧减去attack_fireN.smd动画的每一帧，得到delta动画"attack_anim"，attack_fireN.smd是需要减去的动画
$animation "attack_anim" "getdelta/attack_fireN.smd"{           
    subtract ads_out_animN 10                              
}

//为了使qc能够编译而添加的命令，没有实际用处，指向和$model一样的文件即可
$sequence "AAA" "v_desert_eagle.smd"               

```

根据上面的模板改为你的模型文件和动画，并确定按照你设置的路径放好了动画文件和模型文件。

然后使用crowbar进行编译得到mdl文件，再将mdl文件使用crowbar进行反编译，就能得到你想要的delta动画了，如果按照上面的qc文件内容，最后会得到名为“attack_anim.smd”的delta动画文件。

### 注意事项/小技巧

- 推荐删除qc文件中原来的`$definebone`,使用由crowbar编译你新的合并骨架的模型文件得到的$definebone是比较好的选择。
- 可以添加额外新的的动画`$animation`和动画序列`$sequence`,但是不能破坏原来的qc文件中的`$sequence`顺序，否则会导致非本地游玩不能正确调用动画要添加新的就在qc最后面添加。
- 如果你需要编译的模型有大量的材质，和超多的骨骼数，那么普通游戏的`studiomdl`往往是不能将其编译的。你可以下载使用CSGO的SDK，然后安装`Cra0`的修改版`studiomdl`（[链接](https://cra0.net/blog/posts/archived/2014/studiomdl-2013/)）